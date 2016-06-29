function FindProxyForURL(url, host)
{
  if (host.match('^i-.*') || host.match('silver.musta.ch') || host.match('gold.musta.ch')) {
    return "SOCKS5 127.0.0.1:8527";
  }
  return "DIRECT";
}
