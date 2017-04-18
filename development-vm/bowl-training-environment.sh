#!/bin/bash

# Start all apps that are required in the training environment along with
# setting the relevant environment variables to use real signon, display
# images from production where they don't exist locally, and use the local
# MailHog SMTP port to capture emails. This script is used for development
# of the training environment, since it uses bowl rather than upstart which is
# used in the training environment.

GDS_SSO_STRATEGY=real SHOW_PRODUCTION_IMAGES=true SMTP_PORT=1025 bowl calculators calendars collections collections-publisher contacts-admin contacts-frontend content-tagger designprinciples email-alert-frontend feedback finder-frontend frontend government-frontend draft-government-frontend info-frontend licencefinder local-links-manager manuals-frontend draft-manuals-frontend manuals-publisher maslow policy-publisher publisher router draft-router service-manual-frontend service-manual-publisher signon smartanswers specialist-frontend draft-specialist-frontend specialist-publisher travel_advice_publisher whitehall
