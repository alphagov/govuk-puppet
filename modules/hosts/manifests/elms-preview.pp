class hosts::elms-preview {
  host { 'elms-frontend':      ip => '10.237.35.45' }
  host { 'elms-mongo-1':       ip => '10.234.74.235' }
  host { 'elms-mongo-2':       ip => '10.229.30.142' }
  host { 'elms-mongo-3':       ip => '10.234.81.24' }
  host { 'places-api':         ip => '10.229.118.175' }
}
