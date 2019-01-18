# Dependency management

-   Prefer `require` to `before`.
-   Don't break encapsulation. In particular, a resource within one module
    should not create a dependency (require or notify) to a resource deep within
    another. For example, `File[/etc/nginx/sites-available/foo]` from module
    `foo` should *not* directly notify `Service[nginx]` in module `nginx`.
    Instead consider these options:
  -   use `contain` in modules to ensure dependencies are inherited to contained
      classes correctly, and specify the dependency at the top level. In our
      example, this means we would have:

        ```
        class {'foo': notify => Class['nginx']}
        class {'nginx':}
        ```

  -   create a defined type within one module which other modules can use
      which will set up the correct dependencies. See `nginx::config::site`
      for an example -- this is a defined type which allows other modules
      to create an nginx configuration and will make sure it happens after
      `nginx::package` and before `nginx::service`, without the other module
      even knowing the existence of these classes.
-   When a class includes or instantiates another class, consider whether
    you should use `contain` instead of `include` or `class`. See the
    [Puppet documentation](https://puppet.com/docs/puppet/6.1/lang_containment.html).
	 If class `a` contains class `b` then any resource relationships made to
    class `a` also apply to class `b`.
