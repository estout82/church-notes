
**organizations**
represents top level unit
can have multiple accounts
- name

**accounts**
represents one account (think campus), orgs can have many, have a 'main' account by default
billable unit
- organization_id
- name

**subscriptions**
represents a customer paying for something. this could be a free, base, or multisite paying for all features or a multisite subaccount. each of these has a 
unique stripe subscription and customer
- status
    - none: has never been activated by a paid invoice or sub created in stripe
    - active: needs to be active to use product
    - canceled:
    - failed: payment failed
    - inactive: inactive for some other reason

**users**
- first_name
- last_name
- email
- password_digest
- provider: database, azure

**user_tokens**
used in magic links
- token
- user_id
- action: password_reset, activate

**user_accounts**
relates users to accounts with a permission level
- user_id
- account_id
- roles: viewer, editor, scheduler, admin

**notes**
represents content of the note
- account_id
- title
- background_color
- content: json representing the 'blocks' [ { type: 'h1', data: { text: '', color: '' } } ] ...

blocks json
- h1, h2, h3, text, image, ul, ol, image, fill-in
[ { type: 'h1', data: { text, justify: [center, left, right], bold, italic, color } } ]
[ { type: 'h2', data: { text, justify: [center, left, right], bold, italic, color } } ]
[ { type: 'h3', data: { text, justify: [center, left, right], bold, italic, color } } ]
[ { type: 'text', data: { text, justify: [center, left, right], bold, italic, color } } ]
[ { type: 'image', data: { asset_id } } ]
[ { type: 'ul', data: { items: [ { text block }, { text block } ] } ]
[ { type: 'ol', data: { items: [ { text block }, { text block } ] } ]
[ { type: 'fill-in', data: { placeholder, color, bold, italic } } ]
- all text can be centered, bold, italic, left or right just, colored

**schedules**
- note_id
- start_at
- end_ad

**assets**
- url
- type: image
- width
- height