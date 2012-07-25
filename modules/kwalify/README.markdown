## puppetlabs-kwalify module

### Overview

This is the puppetlabs-kwalify module.

### Disclaimer

Warning! While this software is written in the best interest of quality it has
not been formally tested by our QA teams. Use at your own risk, but feel free
to enjoy and perhaps improve it while you do.

Please see the included Apache Software License for more legal details
regarding warranty.

### Installation

From github, download the module into your modulepath on your Puppetmaster. If
you are not sure where your module path is try this command:

    puppet --configprint modulepath

You will also need the kwalify gem. You can do this using your OS, or using the
gem command:

    gem install kwalify

Depending on the version of Puppet, you may need to restart the puppetmasterd
(or Apache) process before the functions will work.

## Functions

### kwalify

This function allows you to validate Puppet data structures using Kwalify 
schemas as documented here:

http://www.kuwata-lab.com/kwalify/ruby/users-guide.01.html

To validate, create a schema in Puppet:

    $schema = {
      'type' => 'seq',
      'sequence' => [
        { 'type' => 'str' }
      ]
    }

And create some content that you want validated:

    $document = ['a', 'b', 'c']

And then use the function to validate:

    kwalify($schema, $document)

The function will throw an error and list all validation errors if there is a
problem otherwise it succeeds silently. If we break the document on purpose:

    $document = ['a','b',false]

We actually get the precise place it is broken:

    Failed kwalify schema validation:
    [/2] 'false': not a string. at /Users/ken/tmp/kwalify/kwalify1.pp:10 on node kb.local

The number here is 2 as an array is zero-indexed in this case.

### get_scope_args

This function returns a list of arguments passed to the current scope. This
could be a class or defined resource. This allows you to then use the kwalify
function to validate the input for the class or defined resource.

For example:

    class my_database (
      $db_name = "accounts",
      $size = "100 GB",
      $replicate = true
      ) {

      $args = get_scope_args()
      notice(inline_template("<%= args.inspect %>"))
    }

    class { "my_database":
      replicate => false,
    }

Running this will return:

    notice: Scope(Class[My_database]): {"replicate"=>false, "size"=>"100 GB", "db_name"=>"accounts"}

Now to achieve validation you can combine this with kwalify as per the
following:

    class my_database (
      $db_name = "accounts",
      $size = "100 GB",
      $replicate = true
      ) {

      $args = get_scope_args()

      $schema = {
        'type' => 'map',
        'mapping' => {
          'db_name' => {
            'type' => 'str',
            'pattern' => '/^\w+$/',
          },
          'size' => {
            'type' => 'str',
            'pattern' => '/^\d+\s(P|T|G|M|K)B$/',
          },
          'replicate' => {
            'type' => 'bool',
          },
        }
      }

      kwalify($schema, $args)

    }

    class { "my_database":
      replicate => false,
    }

This is obviously an example of a good example so running this content should
give you a good build:

    notice: Finished catalog run in 1.23 seconds

So now lets pass a bad argument. Lets try a 'replicate' attribute which is
invalid:

    class { "my_database":
      replicate => "this is not valid!",
    }

Upon running with this invalid content you should get something like:

    Failed kwalify schema validation:
    [/replicate] 'this is not valid!': not a boolean. at /Users/ken/tmp/kwalify/test3.pp:26 on node kb.local

Setting multiple invalid arguments should result in a report which shows all
bad arguments:

    class { "my_database":
      replicate => "this is not valid!",
      size => "100 YB",
    }

And now the result is:

    Failed kwalify schema validation:
    [/replicate] 'this is not valid!': not a boolean.
    [/size] '100 YB': not matched to pattern /^\d+\s(G|M|K)B$/. at /Users/ken/tmp/kwalify/test4.pp:26 on node kb.local

Which is perfect, as now you don't need to keep fixing items and testing.
Aggregate validation reporting such as this means you get all bad cases in one
go.
