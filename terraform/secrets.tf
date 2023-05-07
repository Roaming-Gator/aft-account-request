# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "secrets-email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "secrets"
    })
    type = "json"
  }
}

# note to self: make sure to add this account to control tower as
# a delegated admin
module "secrets" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.secrets-email.result
    AccountName  = "secrets"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Security"
    # Syntax for nested OU
    SSOUserEmail     = data.jinja_template.secrets-email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  change_management_parameters = {
    change_requested_by = "Paul Nickerson"
    change_reason       = "Cross-account secrets"
  }
  account_tags = {
    "environment" = "prod"
  }

  account_customizations_name = "secrets"
}
