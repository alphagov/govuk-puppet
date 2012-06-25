class hosts::places-preview {
  host { 'places-mongo-1':  ip => '10.239.81.159' }
  host { 'places-mongo-2':  ip => '10.234.37.141' }
  host { 'places-mongo-3':  ip => '10.234.78.68' }
}
