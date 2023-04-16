# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "slackgpt-dev-email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "slackgpt-dev"
    })
    type = "json"
  }
}

module "slackgpt-dev" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.slackgpt-dev-email.result
    AccountName  = "slackgpt-dev"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Deployments"
    # Syntax for nested OU
    # ManagedOrganizationalUnit = "Sandbox (ou-xfe5-a8hb8ml8)"
    SSOUserEmail     = data.jinja_template.slackgpt-dev-email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  change_management_parameters = {
    change_requested_by = "Paul Nickerson"
    change_reason       = "Slackgpt dev deployment"
  }
  account_tags = {
    "environment" = "dev"
  }

  account_customizations_name = "slackgpt"
}
