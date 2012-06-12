class hosts::ertp-staging {
  host { 'ertp-ems-api':      ip => '10.32.5.251' }
  host { 'ertp-citizen-api':  ip => '10.241.67.78' }
  host { 'ertp-mongo-1':      ip => '10.234.119.78' }
  host { 'ertp-mongo-2':      ip => '10.229.123.95' }
  host { 'ertp-mongo-3':      ip => '10.234.43.20' }
}
