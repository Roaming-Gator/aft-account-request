# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "secret-email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "secret"
    })
    type = "json"
  }
}

module "secret" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.secret-email.result
    AccountName  = "secret"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Security"
    # Syntax for nested OU
    SSOUserEmail     = data.jinja_template.secret-email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  change_management_parameters = {
    change_requested_by = "Paul Nickerson"
    change_reason       = "Secrets account deployment"
  }
  account_tags = {
    "environment" = "prod"
  }

  account_customizations_name = "secret"
}
