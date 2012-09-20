class haproxy {
  include concat::setup
  concat {'/foo.txt':}
  concat::fragment {'foo1':
    target => '/foo.txt',
    content => "bazinga\n",
    order => 01,
  }
  concat::fragment {'foo2':
    target => '/foo.txt',
    content => "bazinga number 2\n",
    order => 02,
  }
  
}