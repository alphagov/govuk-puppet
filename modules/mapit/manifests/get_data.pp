define mapit::get_data(
    $mapit_datadir = '/data/vhosts/mapit',
    $base_url      = 'http://parlvid.mysociety.org:81/os/',
    $file_onspd    = 'ONSPD_FEB_2012_UK_O.zip',
    $file_bdline   = 'bdline_gb-2012-05.zip',
    $file_codepo   = 'codepo_gb-2012-02.zip') {

    file { "$mapit_datadir/data/bdline":
      ensure  => directory,
      owner   => 'mapit',
      group   => 'mapit',
      mode    => '0755',
      require => User['mapit'],
    }


    wget::fetch {'onspd_download':
      source      => "${base_url}/${file_onspd}",
      destination => "${mapit_datadir}/data/${file_onspd}",
      require     => File[$mapit_datadir],
    }

    wget::fetch {'bdline_download':
      source      => "${base_url}/${file_bdline}",
      destination => "${mapit_datadir}/data/${file_bdline}",
      require     => File["${mapit_datadir}/data/bdline"],
    }

    wget::fetch {'codepo_download':
      source      => "${base_url}/${file_codepo}",
      destination => "${mapit_datadir}/data/${file_codepo}",
      require     => File[$mapit_datadir],
    }

    exec {'unzip_codepo':
      command   => "/usr/bin/unzip -d ${mapit_datadir}/data ${mapit_datadir}/data/${file_codepo}",
      unless    => "test -s ${mapit_datadir}/data/Code-Point\ Open/readme.txt",
      require   => Wget::Fetch['codepo_download'],
    }

    exec {'unzip_bdline':
      command   => "/usr/bin/unzip -d ${mapit_datadir}/data/bdline ${mapit_datadir}/data/${file_bdline}",
      unless    => 'test -s /data/vhosts/mapit/data/bdline/Docs/licence.txt',
      require   => Wget::Fetch['bdline_download'],
    }

    exec {'unzip_onspd':
      command   => "/usr/bin/unzip -d ${mapit_datadir}/data ${mapit_datadir}/data/${file_onspd}",
      unless    => "test -s ${mapit_datadir}/data/${file_onspd}",
      require   => Wget::Fetch['onspd_download'],
    }

  }
