# Private class: See README.md.
class pcp::resources {

  create_resources('pcp::pmda', $pcp::pmdas)
  create_resources('pcp::pmlogger', $pcp::pmlogger)

}
