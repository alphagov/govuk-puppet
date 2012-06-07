class hosts::ertp-staging {
  host { 'ertp-ero-api':    	ip => '10.239.86.141' }
  host { 'ertp-citizen-api':    ip => '10.239.86.141' }
  host { 'ertp-mongo-1':  		ip => '10.236.89.222' }
  host { 'ertp-mongo-2':  		ip => '10.236.89.222' }
  host { 'ertp-mongo-3':  		ip => '10.236.89.222' }
}
