package com.rjfun.cordova.httpd;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Properties;

public class WebServer extends NanoHTTPD
{
	private String errorPath;

	public WebServer(InetSocketAddress localAddr, AndroidFile wwwroot, String errorPath) throws IOException {
		super(localAddr, wwwroot);
		this.errorPath = errorPath;
	}

	public WebServer(int port, AndroidFile wwwroot, String errorPath) throws IOException {
		super(port, wwwroot);
		this.errorPath = errorPath;
	}

	@Override
	public Response serveFile( String uri, Properties header, AndroidFile homeDir,
							   boolean allowDirectoryListing )
	{
		Response res = super.serveFile(uri, header, homeDir, allowDirectoryListing);

		if (res.status == HTTP_NOTFOUND) {
			res = super.serveFile(errorPath, header, homeDir, allowDirectoryListing);
		}

		return res;
	}
}
