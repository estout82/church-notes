
**organizations**
- these are stripe customers

**billings**
- these are stripe subscriptions

**accounts**
- these are not related to stripe
- store a reference to billing

### Free Sign-Up
- select plan
- redirected to stripe billing portal
- enter info
- single billing, user, and account created
- manage billing info goes to the stripe billing portal

### Base Sign-Up
- select plan
- redirected to stripe billing portal
- enter info
- single billing, user, and account created
- manage billing info goes to the stripe billing portal

### Multi-Site Sign-Up
- select plan & sub-account count
- redirected ot stripe billing portal
- enter info
- single billing created line items: (1 multisite plan + every sub-account)
- main and all sub-accounts created and assigned billing
- can go back and edit sub account billing
    - will create a new subscription for sub-account and edit the main subscription to be cheaper
    - vice-a-versa if sub-account billing is removed
    - manage billing info link will go to that stripe subscription

- if a sub-account sub fails, sub-account is suspended
- if a main account sub fails, all accounts that are being billed from that sub are suspended