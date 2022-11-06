require 'erb'

size = 9
moku = 5
result = ERB.new(DATA.read).result(binding)
puts result.gsub(/( *\n)* *\n/, "\n")
__END__
<style>
  .grid, #win-w, #win-b {
    position: absolute;
    left: 16px;
    top: 16px;
    width: <%= size * 80 %>px;
    height: <%= size * 80 %>px;
    border: 2px solid black;
    box-sizing: content-box;
  }
  .grid {
    display: grid;
    grid-template-columns: <%= (['80px'] * size).join(' ') %>;
  }
  .labels.grid > div {
    overflow: hidden;
  }
  .grid > div, .grid > input {
    width: 80px;
    height: 80px;
    border: 2px solid black;
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    position: relative;
  }
  body {
    counter-reset: bmoves 1000 wmoves 0;
  }
  input { display: none; }
  input:checked { display: block; }
  input[value="b"]:checked { counter-increment: wmoves 1000 bmoves -1000; }
  input[value="w"]:checked { counter-increment: wmoves -1000 bmoves 1000; }
  input:checked::before {
    background: white;
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
    font-size: 48px;
  }
  input[value="b"]:checked::before {
    content: '🌺'
  }
  input[value="w"]:checked::before {
    content: '🏝'
  }
  .labels .w, .labels .b {
    position: absolute;
    left: -80px;
    top: 0px;
    white-space: nowrap;
    height: 0;
  }
  .labels label {
    display: inline-block;
    width: 160px;
    height: 160px;
  }
  .labels .w::before, .labels .b::before {
    font-size: 100px;
  }
  .labels .w::before {
    content: counter(bmoves);
  }
  .labels .b::before {
    content: counter(wmoves);
  }
  input:checked::after {
    display: none;
    position: absolute;
    border: 8px solid rgba(255, 160, 0, 0.4);
    box-sizing: border-box;
    border-radius: 40px;
    height: 80px;
    transform-origin: 40px 40px;
    z-index: 1;
  }
  <% [*0...size].product([*0...size]).map(&:join).each do |ij| %>
  body:has(input[name="<%= ij %>"].filled:checked) .l<%= ij %> { display: none; }
  <% end %>
  <% ['b', 'w'].each do |which| %>
    <% horizontal = (%W[input[value="#{which}"]:checked] * moku).join((['+'] * 3).join('*')) %>
    <% vertical = (%W[input[value="#{which}"]:checked] * moku).join((['+'] * (3 * size + 1)).join('*')) %>
    <% diagonal1 = (%W[input[value="#{which}"]:checked] * moku).join((['+'] * (3 * (size + 1) + 1)).join('*')) %>
    <% diagonal2 = (%W[input[value="#{which}"]:checked] * moku).join((['+'] * (3 * (size - 1) + 1)).join('*')) %>
    <% [horizontal, vertical, diagonal1, diagonal2].each do |selector| %>
  body:has(<%= selector %>) #win-<%= which %> { display: flex; }
    <% end %>
  <%= horizontal %>::after {
    width: <%= moku * 80 %>px;
    transform: rotate(-180deg);
    display: block;
    content: '';
  }
  <%= vertical %>::after {
    width: <%= moku * 80 %>px;
    transform: rotate(-90deg);
    display: block;
    content: '';
  }
  <%= diagonal1 %>::after {
    width: <%= 80 * (1 + (moku - 1) * 2 ** 0.5) %>px;
    transform: rotate(-135deg);
    display: block;
    content: '';
  }
  <%= diagonal2 %>::after {
    width: <%= 80 * (1 + (moku - 1) * 2 ** 0.5) %>px;
    transform: rotate(-45deg);
    display: block;
    content: '';
  }
  <% end %>
  #win-b, #win-w {
    display: none;
    background: rgba(0, 0, 0, 0.2);
    justify-content: center;
    align-items: center;
    border-color: transparent;
    z-index: 2;
  }
  #win-b div, #win-w div {
    font-size: 48px;
    padding: 32px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.8);
  }
  .separator { display: none; }
</style>

<div class="checkboxes grid">
  <% size.times do |i| %>
    <% size.times.map { "#{i}#{_1}" }.each do |ij| %>
  <input type="radio" id="<%= ij %>-b" name="<%= ij %>" class="filled" value="b"><input type="radio" id="<%= ij %>-w" name="<%= ij %>" class="filled" value="w"><input type="radio" name="<%= ij %>" checked>
    <% end %>
  <div class="separator"></div>
  <% end %>
</div>
<div class="labels grid">
  <% [*0...size].product([*0...size]).map(&:join).each do |ij| %>
  <div><div class="b l<%= ij %>"><label for="<%= ij %>-b"></label></div><div class="w l<%= ij %>"><label for="<%= ij %>-w"></label></div></div>
  <% end %>
</div>
<div id="win-b">
  <div>Winner: 🌺</div>
</div>
<div id="win-w">
  <div>Winner: 🏝</div>
</div>
