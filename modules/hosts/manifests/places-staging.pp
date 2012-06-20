class hosts::places-staging {
  host { 'places-mongo-1':      ip => '' }
  host { 'places-mongo-2':      ip => '' }
  host { 'places-mongo-3':      ip => '' }
}
