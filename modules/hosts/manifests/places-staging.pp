class hosts::places-staging {
  host { 'places-mongo-1':      ip => '10.228.167.31' }
  host { 'places-mongo-2':      ip => '10.234.122.78' }
  host { 'places-mongo-3':      ip => '10.234.5.12' }
  host { 'monitoring.cluster':  ip => '10.51.62.202' }
}
