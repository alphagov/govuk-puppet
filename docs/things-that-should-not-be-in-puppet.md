# Things that should not be in Puppet

-   **Secrets**. It is bad practice to embed your secret data (passwords,
    tokens etc.) within Puppet. To do so means that even if you specify that a
    secret applies to one particular environment it is available on the
    PuppetMaster for every environment. It is good practise to store
    secrets in the `govuk-secrets` repo at `puppet/hieradata/${environment}.yaml`.
    Please make sure where necessary you have different secrets for each value.

-   **Per-environment switches**. The Puppet repo should not know the
    specifics of each environment. By switching on platform or environment
    variables, you make it difficult to add new platforms and hard to ensure
    that consistent behaviour is applied across all environments. To apply a
    catalog item to a subset of environments you should:
    1. Add a feature toggle to Hiera (default goes in `common.yaml`, per
       environment value goes in `${environment}.yaml`. Be aware that
       Hieradata for environments is in the `govuk-secrets` repo. `common.yaml`
       exists in both repos.
    2. Switch on resources based on the feature toggle in Hieradata:
       [Puppet/modules/govuk/manifests/node/s_base.pp#L38-L40]
       (https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/node/s_base.pp#L38-L40)
    3. Where possible, create your switches at the machine manifest level (as
       above) rather than within a module.
