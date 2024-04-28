locals {
  default_template_variables = {
    data_factory_name = azurerm_data_factory.data_factory.name
  }
  template_variables = merge(local.default_template_variables, var.custom_template_variables)
}
