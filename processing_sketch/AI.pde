String askAI(String prompt) {
  try {
    URL url = new URL("http://localhost:8000/ask");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
    conn.setDoOutput(true);

    JSONObject payload = new JSONObject();
    payload.setString("prompt", prompt);

    OutputStream os = conn.getOutputStream();
    byte[] input = payload.toString().getBytes("UTF-8");
    os.write(input, 0, input.length);
    os.flush();
    os.close();

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder response = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      response.append(line);
    }
    reader.close();

    JSONObject jsonObj = parseJSONObject(response.toString());
    String reply = jsonObj.getString("response");

    gotResponse = true;
    state = "showingTips";

    return reply;
  } catch (Exception e) {
    e.printStackTrace();
    return "Erro ao comunicar com o servidor.";
  }
}

// funcao do tts
void speakTips() {
  try {
    URL url = new URL("http://localhost:8000/speak");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
    conn.setDoOutput(true);

    JSONObject payload = new JSONObject();
    payload.setString("text", tips);

    OutputStream os = conn.getOutputStream();
    byte[] input = payload.toString().getBytes("UTF-8");
    os.write(input, 0, input.length);
    os.flush();
    os.close();

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder response = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      response.append(line);
    }
    reader.close();

    JSONObject jsonObj = parseJSONObject(response.toString());
    boolean success = jsonObj.getBoolean("success");

    if (!success) {
      println("Error with text-to-speech: " + jsonObj.getString("message"));
      isSpeaking = false;
    }
  } catch (Exception e) {
    e.printStackTrace();
    println("Error connecting to TTS server");
    isSpeaking = false;
  }
}

void stopSpeaking() {
  try {
    URL url = new URL("http://localhost:8000/stop_speaking");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.connect();
    
    int responseCode = conn.getResponseCode();
    if (responseCode != 200) {
      println("Failed to stop speaking, server returned code: " + responseCode);
    }
    isSpeaking = false;
  } catch (Exception e) {
    e.printStackTrace();
    println("Error stopping TTS");
  }
}
