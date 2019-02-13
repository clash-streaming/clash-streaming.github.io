---
layout: default
---

The terms and definitions we use in CLASH.

{% assign glossary = site.data.glossary | sort %}
{% for outer_entry in glossary %}
  <h2>{{ outer_entry[0] }}</h2>
  {% assign inner_glossary = outer_entry[1] | sort %}
  <table>
    <thead>
      <tr>
        <th>Term</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      {% for inner_entry in inner_glossary %}
        <tr>
          <td>{{ inner_entry[1]['name'] }}</td>
          <td> {{ inner_entry[1]['def'] }} </td>
        </tr>
      {% endfor %}
    </tbody>
  </table>
{% endfor %}

