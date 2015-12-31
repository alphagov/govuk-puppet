# Node defintion for mirrorer-?.management boxen
class govuk::node::s_mirrorer inherits govuk::node::s_base {
  include govuk_crawler
  include nginx
}
