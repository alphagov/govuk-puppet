class hosts::places_preview {
  host { 'places-mongo-1':     ip => '10.239.81.159' }
  host { 'places-mongo-2':     ip => '10.234.37.141' }
  host { 'places-mongo-3':     ip => '10.234.78.68' }
  host { 'monitoring.cluster': ip => '10.51.62.202' }

}
