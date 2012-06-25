class hosts::ertp-preview {
  host { 'ertp-api':    ip => '10.239.86.141' }
  host { 'ertp-mongo':  ip => '10.236.89.222' }
  host { 'places-api':  ip => '10.229.118.175' }
}
