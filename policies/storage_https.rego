package terraform.analysis

resouce_not_in_norwayeast[resource] {
    resource := input.resource_changes[_].change.after
    resource.location != "norwayeast"
}

deny[msg] {
    resource := resouce_not_in_norwayeast[_]
    msg = sprintf("Resouce %s is not located in norwayeast.", [resouce.name])
}