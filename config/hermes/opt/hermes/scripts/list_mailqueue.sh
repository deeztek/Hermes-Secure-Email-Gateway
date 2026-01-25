/usr/local/bin/docker exec hermes_postfix_dkim /usr/bin/mailq | awk '
BEGIN {
    print "\"QueueID\",\"Sender\",\"Recipient\",\"ConnectionStatus\",\"MsgStatus\""
}
/^[A-Z0-9]/ {
    raw_id = $1
    msgstatus = "N/A"
    queue_id = raw_id
    if (index(queue_id, "!")) {
        msgstatus = "ON-HOLD"
        gsub("!", "", queue_id)
    } else if (index(queue_id, "*")) {
        msgstatus = "ACTIVE"
        gsub("\\*", "", queue_id)
    }
    sender = $(NF)
    getline
    connstatus = $0
    gsub(/^[ \t]+/, "", connstatus)
    getline
    recipient = $1
    gsub(/^[ \t]+/, "", recipient)
    gsub(/"/, "\"\"", queue_id)
    gsub(/"/, "\"\"", sender)
    gsub(/"/, "\"\"", recipient)
    gsub(/"/, "\"\"", connstatus)
    print "\"" queue_id "\",\"" sender "\",\"" recipient "\",\"" connstatus "\",\"" msgstatus "\""
}' > /opt/hermes/tmp/THE-TRANSACTION-mailqueue_list
