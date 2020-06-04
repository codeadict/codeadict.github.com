---
layout: page
---

<header>
  <h2>Dairon Medina Caro</h2>
</header>


<p>
<div class="photo"><figure><img src="{{ site.url }}/imgs/photo.png" alt="Me" sizes="(max-width: 204px) 100vw, 204px" width="204" height="204"></figure></div>
Hello world! I'm Dairon(/Daɪron̩/) Medina, a <b>Florida</b> based freelance <a href="https://redclawtech.com">software consultant</a> who has been <b>building software for over 12 years</b>.
</p>
<p>
 I help tech companies develop and scale their real-time web and IoT architectures leveraging great tools like Erlang/Elixir and Golang. My services include custom development, support and consulting on Device to Cloud communication, Websockets, MQTT, WebRTC and highly scalable IoT backends that need to ingest and process millions of datapoints in a reliable and fault-tolerant manner.
</p>

<h3 id="contact-info">Get in Touch</h3>
Have further questions? Wanna say hello? Get in touch through one of these channels:
<ul class="contact">
<li><strong>Email:</strong> <a href="mailto:me@dairon.org">me@dairon.org</a></li>
<li><strong>LinkedIn:</strong> <a href="https://www.linkedin.com/in/codeadict/">https://www.linkedin.com/in/codeadict/</a></li>
<li><strong>Github:</strong> <a href="https://github.com/codeadict">https://github.com/codeadict</a></li>
</ul>

<h3 id="articles">Articles</h3>
<ul>
{% for post in site.posts %}
<li>
<a class="text-gray-dark" href="{{ post.url | relative_url }}">
{{ post.date | date: "%b %-d, %Y" }} : {{ post.title | escape }}
</a>
</li>
{% endfor %}
</ul>