
$0 ~ /^#/ {
    match($0,/id="([0-9]+)"/,a)
    id = a[1]
    match($0,/ref="([^"]+)"/,a)
    ref = a[1]
    match($0,/source="([^"]+)"/,a)
    source = a[1]
    match($0,/text="([^"]+)"/,a)
    text = a[1]
    print "# id = " id
    print "# text = " text
    print "# source = " source
    print "# sent_id = " ref
    next
}

{ print }
