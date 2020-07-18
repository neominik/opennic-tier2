# opennic-tier2

A tier 2 recursive DNS resolver for OpenNIC TLDs using bind. Based on this [Opennic Tutorial](https://wiki.opennic.org/opennic/srvzone).

## Considerations

Please keep the following in mind when deciding whether or not to run a public Tier 2 server, some considerations are involved.

- Your server and network equipment, including your internet connection, must be reliable.
- Typical bandwidth usage may only be a few-hundred MB/month, but without proper protection and rate limiting, a DDoS attack can easily put you into hundreds of gigabytes in a few days!
- You will personally need to monitor your equipment and be willing to quickly resolve any failures. This includes having the knowledge to troubleshoot both hardware and software failures.
- When your service becomes unavailable from the internet for more than two hours, you will receive an automated email warning. Please do not ignore these emails – you will only receive them when there is a problem.
- Tier 2 servers **will** experience DDoS attacks. Please be sure to visit the [Tier 2 Security](https://wiki.opennic.org/opennic/tier2security) page for information on how to mitigate these attacks. Other members will do what they can to provide assistance, however ultimately it is your responsibility to ensure that your own servers do not participate in man-in-the-middle or amplification attacks. You do not want to become part of an attack!
- Various attacks will use up a lot of bandwidth. If your provider places data caps on your monthly internet usage, you may want to reconsider having a public service. Every attack is different, so no predictions can be on what your data usage will be each month – however as an example, attacks can continue for several months and have been known to blast up to 20Mb/s of queries to an individual server. If you wish to run a public service, be prepared for the worst!
- This image has no rate limiting or other mitigations against DDoS attacks integrated! You probably should not blindly expose it on a public IP address.

## How to Run

Quickest way, using defaults:

```docker run --name opennic --init --rm -p 53:53 neominik/opennic-tier2```

Running with the `--init` option is recommended, so the processes can terminate properly.

Custom configuration can be done by mounting a `named.conf` to `/etc/bind/named.conf`. It should, however, include the opennic configuration at `/etc/bind/named.conf.opennic`.

Options to the underlying `named` process can be passed with a custom command.



## Compose

Example `docker-compose.yml` file:

```yaml
version: '3.8'
services:

  opennic:
    image: neominik/opennic-tier2
    container_name: opennic
    init: true
    restart: unless-stopped
    networks:
      - dnsnet
  
  # Optional to enable DoH
  doh-server:
    image: neominik/doh-server
    container_name: doh-server
    init: true
    environment:
      - SERVER_ADDR=opennic:53
    restart: unless-stopped
    networks:
      - dnsnet
```
