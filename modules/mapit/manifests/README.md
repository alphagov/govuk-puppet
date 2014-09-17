# MapIt - postcode and boundary lookup 

## Introduction

MapIt is a product of MySociety which we use within GOV.UK to allow people to enter their
postcode and be pointed to their local services.

It is composed of broadly 2 things:

1. A database of postcodes and the location of their geographical centre
2. A database of administrative entities (e.g. local councils) and their boundaries on a map

When a user enters a postcode on GOV.UK, MapIt will look it up to find the geographical
centre and then return information about the administrative entities that postcode belongs
to. We then use this information to refer the user to local services provided by those entities.

It looks something like this:

```
$ curl http://localhost/postcode/SW1A1AA
{
  "wgs84_lat": 51.50100893647978,
  "coordsyst": "G",
  "shortcuts":
    {
      "WMC": 22695,
      "ward": 7212,
      "council": 1990
    },
  "wgs84_lon": -0.14158760012261312,
  "postcode": "SW1A 1AA",
  "easting": 529090,
  "areas":
    {
      "9728":
        {
          "parent_area": null,
          "generation_high": 3,
          "all_names": {},
          "id": 9728,
          "codes":
            {
              "ons": "07",
              "gss": "E15000007",
              "unit_id": "41428"
            },
          "name": "London",
          "country": "E",
          "type_name": "European region",
          "generation_low": 1,
          "country_name": "England",
          "type": "EUR"
        },
      "1990":
        {
          "parent_area": null,
          "generation_high": 3,
          "all_names": {},
          "id": 1990,
          "codes":
            {
              "ons": "00BK",
              "gss": "E09000033",
              "unit_id": "11164"
            },
          "name": "City of Westminster Borough Council",
          "country": "E",
          "type_name": "London borough",
          "generation_low": 1,
          "country_name": "England",
          "type": "LBO"
        },
      "1766":
        {
          "parent_area": null,
          "generation_high": 3,
          "all_names": {},
          "id": 1766,
          "codes":
            {
              "unit_id": "41441"
            },
          "name": "Greater London Authority",
          "country": "E",
          "type_name": "Greater London Authority",
          "generation_low": 1,
          "country_name": "England",
          "type": "GLA"
        },
      "22695":
        {
          "parent_area": null,
          "generation_high": 3,
          "all_names": {},
          "id": 22695,
          "codes":
            {
              "ons": "B11",
              "gss": "E14000639",
              "unit_id": "25040"
            },
          "name": "Cities of London and Westminster",
          "country": "E",
          "type_name": "UK Parliament constituency",
          "generation_low": 1,
          "country_name": "England",
          "type": "WMC"
        },
      "7212":
        {
          "parent_area": 1990,
          "generation_high": 3,
          "all_names": {},
          "id": 7212,
          "codes":
            {
              "ons": "00BKGQ",
              "gss": "E05000644",
              "unit_id": "11162"
            },
          "name": "St James's",
          "country": "E",
          "type_name": "London borough ward",
          "generation_low": 1,
          "country_name": "England",
          "type": "LBW"
        },
      "9750":
        {
          "parent_area": 1766,
          "generation_high": 3,
          "all_names": {},
          "id": 9750,
          "codes":
            {
              "ons": "",
              "gss": "E32000014",
              "unit_id": "41449"
            },
          "name": "West Central",
          "country": "E",
          "type_name": "London Assembly constituency",
          "generation_low": 1,
          "country_name": "England",
          "type": "LAC"
        }
    },
  "northing": 179645
}
```

## Updating Postcodes

Postcode information is published 4 times per year, so it's inevitable that our database will
become out of date and users will start to complain. When they do (or before if possible) we
should update the data.

To update a live mapit server:

1. Download the latest ONS Postcode Database (ONSPD) and Code-Point Open zip files to the
   server from MySociety's cache here: http://parlvid.mysociety.org/os/
2. Read the instructions: http://mapit.poplus.org/docs/self-hosted/import/uk/
3. Scratch your head a lot
4. Give up and follow the rough guide that follows:

```
# on your mac
cd vagrant-govuk
vagrant up mapit-server-1.backend
vagrant ssh mapit-server-1.backend

# you are now on a VM
sudo -iu mapit
cd /data/vhost/mapit/mapit/project
mkdir update_data
cd update_data

# Replace these URLs with the latest versions
wget http://parlvid.mysociety.org/os/ONSPD_MAY_2014_csv.zip
wget http://parlvid.mysociety.org/os/codepo_gb-2014-05.zip
unzip *.zip

# You now have the latest data unzipped in ./Data
cd ../
# you are now in /data/vhost/mapit/mapit/project

# Import the UK postcodes (there's 1.6million of them, go get a coffee)
./manage.py mapit_UK_import_codepoint update_data/Data/CSV/*.csv

# Import the postcodes for the Scilly Isles
./manage.py mapit_UK_scilly update_data/Data/CSV/tr.csv

# Import the postcodes for Northern Ireland
# adjust for the name of your CSV (60000 postcodes, takes a few minutes)
./manage.py mapit_UK_import_nspd_ni update_data/Data/ONSPD_MAY_2014_UK.csv

# Test some postcodes. If you've had users complaining that their postcode isn't recognised,
# then try _those_ postcodes and any other ones you know. If you don't know any postcodes,
# try this random one:
curl http://localhost/postcode/ME206QZ

# Delete the data you downloaded
rm -rf update_data

# Export the database
pg_dump mapit | gzip > mapit-May2014.sql.gz
```

You now need to copy this SQL dump off your VM and arrange to put it onto the
gds-public-readable-tarballs S3 bucket. You can then adjust the URL for the
`mapit_dbdump_download` resource in `govuk/manifests/node/s_mapit_server.pp` and test
that you can bring up a new mapit node from scratch.

Once you have tested that a new mapit node works as expected, you can simply turn off NginX
on the existing MapIt servers one by one, import the new SQL dump into the server and then
start up NginX. We can happily survive with one mapit-server in an environment while this is
done.

```
sudo service nginx stop
sudo service mapit stop
sudo service collectd stop
sudo rm /data/vhost/mapit/data/mapit.sql.gz
sudo -iu postgres psql -c 'DROP DATABASE mapit;'
sudo govuk_puppet -v
```
