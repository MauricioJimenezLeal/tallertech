%dw 2.0
output application/json
var today = now() as Date

fun ageFrom(d) = today.year - d.year - (if ((today.month < d.month) or (today.month == d.month) and (today.day < d.day)) 1 else 0)
    
var src = (payload)
---
{
	customer: {
		customerId: src.customer.customerId default src.customerId,
		externalId: src.customer.externalId default src.externalId,
		firstName: trim(src.customer.name.first default src.name.first),
		lastName: trim(src.customer.name.last default src.name.last),
		fullName: trim(src.customer.name.first default src.name.first) ++ " " ++ trim(payload.customer.name.last default payload.name.last),
		email: src.customer.email default src.email,
		dateOfBirth: src.customer.dob default src.dob,
		age: ageFrom((src.customer.dob default src.dob) as Date {format: "yyyy-MM-dd"}),
		address: {
			street: src.customer.address.line1 default src.address.line1,
			city: src.customer.address.city default src.address.city,
			state: src.customer.address.state default src.address.state,
			postalCode: src.customer.address.postalCode default src.address.postalCode,
			country: src.customer.address.country default src.address.country
		},
		sourceMeta: {
			sourceSystem: src.customer.sourceSystem default src.sourceSystem,
			receivedAt: now()
		}
		
	}
}