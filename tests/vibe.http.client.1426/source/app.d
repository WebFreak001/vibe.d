import vibe.core.core;
import vibe.core.net;
import vibe.http.client;
import vibe.stream.operations;

/// Workaround segv caused by parallel GC
static if (__VERSION__ >= 2087)
    extern(C) __gshared string[] rt_options = [ "gcopt=parallel:0" ];

int main ()
{
	immutable serverAddr = listenTCP(0, (TCPConnection c) @safe nothrow {
		try c.write("HTTP/1.1 200 OK\r\nConnection: Close\r\n\r\nqwerty");
		catch (Exception e) assert(0, e.msg);
	}, "127.0.0.1").bindAddress;

	runTask({
		requestHTTP("http://" ~ serverAddr.toString,
			(scope req) {},
			(scope res) {
				assert(res.bodyReader.readAllUTF8() == "qwerty");
			}
		);
		exitEventLoop();
	});
    return runEventLoop();
}
