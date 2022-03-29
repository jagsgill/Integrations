package layer7.rbac

# This example has been adapted directly from the official OPA Documentation
# https://www.openpolicyagent.org/docs/latest/policy-performance/
bindings := [
	{
		"user": "nina",
		"roles": ["dev", "test", "production"],
	},
	{
		"user": "bruce",
		"roles": ["dev", "test"],
	},
    {
		"user": "arnold",
		"roles": ["test"],        
    },
]

roles := [
	{
		"name": "dev",
		"permissions": [
            {"resource": "accounts", "action": "read"},
			{"resource": "accounts", "action": "write"}
		]
	},
	{
		"name": "test",
		"permissions": [
            {"resource": "accounts", "action": "read"}
            ]
	},
    {
		"name": "production",
		"permissions": [
            {"resource": "accounts", "action": "read"}
            ]
	}
]

# Example RBAC policy implementation.
default allow = false

allow {
    some role_name
    user_has_role[role_name]
    role_has_permission[role_name]
}

user_has_role[role_name] {
    binding := bindings[_]
    binding.user == input.subject
    role_name := binding.roles[_]
}

role_has_permission[role_name] {
    role := roles[_]
    role_name := role.name
    perm := role.permissions[_]
    perm.resource == input.resource
    perm.action == input.action
}
