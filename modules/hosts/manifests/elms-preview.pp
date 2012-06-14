class hosts::elms-preview {
  host { 'elms-frontend':    ip => '10.237.35.45' }
  host { 'elms-mongo':       ip => '10.234.74.235' }
}
