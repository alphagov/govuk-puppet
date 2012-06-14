class hosts::elms-preview {
  host { 'elms-frontend':    ip => '10.239.86.141' }
  host { 'elms-mongo':  ip => '10.236.89.222' }
}
