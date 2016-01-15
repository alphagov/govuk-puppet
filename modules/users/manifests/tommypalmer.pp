# Creates the tommypalmer user
class users::tommypalmer {
  govuk::user { 'tommypalmer':
    fullname => 'Tommy Palmer',
    email    => 'tommy.palmer@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/eDa02Jv1catahUdC/ptvYr8pZrOFuN1efBI3Fn5a80KaMgSNNL1N9FGtLm7JJLg4drK30uME+4Mbb1aVNfRBRZy3LVZ78WlATVHmD2Ft8eu71668IsZT2+cznKmSpmfaPaQFuI+3WSJak0+vcpyRlrw8kZpMDbjnvSDOc53o3FLlgW9x9K0HvvR7DsjTvTjBSud4qD/5IKpbPgSriub0M+930vE9IYu7iIiCtZLdZMmX+JfmOES9mkBgdjDj6tUUie+mf8G4y+bTEMESniVLDFNoN/rB/OO9KgkpZr4Nhb6mmqjqYWiwlyyB4iOxs/UVTARWm/JjLf3Z0TnKhn9kEzPUlPR2yqQOdK4y2Z2WzqGaBmqqcZfZz/HYRa3+tc3m652a9q5n9rzGH9tR6+rBA6DRdAVnxuggp87rdH29aHhlkPopcExUmAMDHRs3iKabHuJTiFc74OLSFCGNLKq3PIYh2V/unfEvWL6vZo2NXQCTeY2+ROGNnX1KibnsHACzyKR5hJorV3oM8+B17unZHtQxGSlfE3lW5ZGzDvIpHtw8h7FhVmxA/+T5uiK9cM02lz13RkLUsPRsHXiccRwemKDoPYJAwK5zxMAjXiJAni37DETcxVSxmnNBEQVnO/OLTfbugEtYawHFn+fNPUUMiPoRx5ZpgM8bf7hYaBr0nQ== tommy.palmer@digital.cabinet-office.gov.uk',
  }
}
