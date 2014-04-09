# At the moment, the Oracle Java 7 package is only shipped as the JDK. If
# someone needs a JRE, they'll just have to install the whole JDK.
class govuk_java::oracle7::jre ( $ensure = present ) inherits govuk_java::oracle7::jdk {
}
