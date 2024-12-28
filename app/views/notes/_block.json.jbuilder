json.id block.guid

json.type block.kind

json.content block.content

json.order block.order

json.data block.meta

if include_children
  json.children block.children.order(:order) do |child|
    json.partial! "notes/block", block: child, include_children: true
  end
end

if block.parent.present?
  json.parent do
    json.partial! "notes/block", block: block.parent, include_children: false
  end
end