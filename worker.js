const ENDPOINTS = [
  "https://drexus-ai.angelarenotfound.workers.dev/chat",
  "https://drexus-ai.darkmagma57.workers.dev/chat",
  "https://drexus-ai.soycrac1998.workers.dev/chat"
];

async function fetchResponse(payload) {
  const endpoint = ENDPOINTS[Math.floor(Math.random() * ENDPOINTS.length)];
  try {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });
    const data = await response.json();
    return { status_code: response.status, response: data };
  } catch (error) {
    return { status_code: 500, response: { error: error.message } };
  }
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === "/" && request.method === "GET") {
      return env.ASSETS.fetch("index.html");
    }

    if (url.pathname === "/status" && request.method === "GET") {
      return new Response(JSON.stringify({
        service: "Drexus API Gateway",
        status: "operational",
        endpoints: ENDPOINTS
      }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    if (url.pathname === "/chat" && request.method === "POST") {
      try {
        const body = await request.json();
        const { model, system, message, max_tokens } = body;

        if (!model || !system || !message || !max_tokens) {
          return new Response(JSON.stringify({
            status_code: 400,
            response: { error: "Missing one or more required fields: model, system, message, max_tokens" }
          }), { status: 400 });
        }

        const result = await fetchResponse({ model, system, message, max_tokens });
        return new Response(JSON.stringify(result), {
          status: result.status_code,
          headers: { "Content-Type": "application/json" }
        });
      } catch {
        return new Response(JSON.stringify({
          status_code: 500,
          response: { error: "Invalid JSON or internal error" }
        }), { status: 500 });
      }
    }

    return env.ASSETS.fetch(request);
  }
};