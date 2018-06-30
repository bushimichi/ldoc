return [==[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=$(ldoc.doc_charset)"/>
<head>
    <title>$(ldoc.title)</title>
    <link rel="stylesheet" href="$(ldoc.css)" type="text/css" />
# if ldoc.custom_css then -- add custom CSS file if configured.
    <link rel="stylesheet" href="$(ldoc.custom_css)" type="text/css" />
# end


<script>
    function sortList(id) {
        var list, i, switching, b, shouldSwitch;
        list = document.getElementById(id);
        switching = true;
        /* Make a loop that will continue until
        no switching has been done: */
        while (switching) {
        // Start by saying: no switching is done:
        switching = false;
        b = list.getElementsByTagName("LI");
        // Loop through all list items:
        for (i = 0; i < (b.length - 1); i++) {
            // Start by saying there should be no switching:
            shouldSwitch = false;
            /* Check if the next item should
            switch place with the current item: */
            if (b[i].innerHTML.toLowerCase() > b[i + 1].innerHTML.toLowerCase()) {
            /* If next item is alphabetically lower than current item,
            mark as a switch and break the loop: */
            shouldSwitch = true;
            break;
            }
        }
        if (shouldSwitch) {
            /* If a switch has been marked, make the switch
            and mark the switch as done: */
            b[i].parentNode.insertBefore(b[i + 1], b[i]);
            switching = true;
        }
        }
    };


    function sortTable(id) {
      var n=0;
      var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
      table = document.getElementById(id);
      switching = true;
      // Set the sorting direction to ascending:
      dir = "asc"; 
      /* Make a loop that will continue until
      no switching has been done: */
      while (switching) {
        // Start by saying: no switching is done:
        switching = false;
        rows = table.getElementsByTagName("TR");
        /* Loop through all table rows (except the
        first, which contains table headers): */
        for (i = 0; i < (rows.length - 1); i++) {
          // Start by saying there should be no switching:
          shouldSwitch = false;
          /* Get the two elements you want to compare,
          one from current row and one from the next: */
          x = rows[i].getElementsByTagName("TD")[n];
          y = rows[i + 1].getElementsByTagName("TD")[n];
          /* Check if the two rows should switch place,
          based on the direction, asc or desc: */
          if (dir == "asc") {
            if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
              // If so, mark as a switch and break the loop:
              shouldSwitch = true;
              break;
            }
          } else if (dir == "desc") {
            if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
              // If so, mark as a switch and break the loop:
              shouldSwitch = true;
              break;
            }
          }
        }
        if (shouldSwitch) {
          /* If a switch has been marked, make the switch
          and mark that a switch has been done: */
          rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
          switching = true;
          // Each time a switch is done, increase this count by 1:
          switchcount ++; 
        } else {
          /* If no switching has been done AND the direction is "asc",
          set the direction to "desc" and run the while loop again. */
          if (switchcount == 0 && dir == "asc") {
            dir = "desc";
            switching = true;
          }
        }
      }
    }

</script>
</head>
<body>

<div id="container">

<div id="product">
	<div id="product_logo"></div>
	<div id="product_name"><big><b></b></big></div>
	<div id="product_description"></div>
</div> <!-- id="product" -->


<div id="main">

# local no_spaces = ldoc.no_spaces
# local use_li = ldoc.use_li
# local display_name = ldoc.display_name
# local iter = ldoc.modules.iter
# local function M(txt,item) return ldoc.markup(txt,item,ldoc.plain) end
# local nowrap = ldoc.wrap and '' or 'nowrap'

<!-- Menu -->

<div id="navigation">
<br/>
<h1>$(ldoc.project)</h1>

# if not ldoc.single and module then -- reference back to project index
<ul>
  <li><a href="../$(ldoc.output).html">Index</a></li>
</ul>
# end

# --------- contents of module -------------
# if module and not ldoc.no_summary and #module.items > 0 then
<h2>Contents</h2>
<ul id="id01">
# for kind,items in module.kinds() do
<li><a href="#$(no_spaces(kind))">$(kind)</a></li>
# end
</ul>
# end
<script>
  sort_list('id01');
</script>


# if ldoc.no_summary and module and not ldoc.one then -- bang out the functions on the side
# for kind, items in module.kinds() do
<h2>$(kind)</h2>
<ul class="nowrap">
# for item in items() do
    <li><a href="#$(item.name)">$(display_name(item))</a></li>
# end
</ul>
# end
# end
# -------- contents of project ----------
# local this_mod = module and module.name
# for kind, mods, type in ldoc.kinds() do
#  if ldoc.allowed_in_contents(type,module) then
<h2>$(kind)</h2>
<ul class="$(kind=='Topics' and '' or 'nowrap')">
#  for mod in mods() do local name = display_name(mod)
#   if mod.name == this_mod then
  <li><strong>$(name)</strong></li>
#   else
  <li><a href="$(ldoc.ref_to_module(mod))">$(name)</a></li>
#   end
#  end
# end
</ul>
# end

</div>

<div id="content">

# if ldoc.body then -- verbatim HTML as contents; 'non-code' entries
    $(ldoc.body)
# elseif module then -- module documentation
<h1>$(ldoc.module_typename(module)) <code>$(module.name)</code></h1>
<p>$(M(module.summary,module))</p>
<p>$(M(module.description,module))</p>
#   if module.tags.include then
        $(M(ldoc.include_file(module.tags.include)))
#   end
#   if module.see then
#     local li,il = use_li(module.see)
    <h3>See also:</h3>
    <ul>
#     for see in iter(module.see) do
         $(li)<a href="$(ldoc.href(see))">$(see.label)</a>$(il)
#    end -- for
    </ul>
#   end -- if see
#   if module.usage then
#     local li,il = use_li(module.usage)
    <h3>Usage:</h3>
    <ul>
#     for usage in iter(module.usage) do
        $(li)<pre class="example">$(ldoc.escape(usage))</pre>$(il)
#     end -- for
    </ul>
#   end -- if usage
#   if module.info then
    <h3>Info:</h3>
    <ul>
#     for tag, value in module.info:iter() do
        <li><strong>$(tag)</strong>: $(M(value,module))</li>
#     end
    </ul>
#   end -- if module.info


# if not ldoc.no_summary then
# -- bang out the tables of item types for this module (e.g Functions, Tables, etc)
# for kind,items in module.kinds() do
<h2><a href="#$(no_spaces(kind))">$(kind)</a></h2>
<table class="function_list" id="function_list">
#  for item in items() do
	<tr>
	<td class="name" $(nowrap)><a href="#$(item.name)">$(display_name(item))</a></td>
	<td class="summary">$(M(item.summary,item))</td>
	</tr>
#  end -- for items
</table>
#end -- for kinds
<script>
  sortTable("function_list");
</script>

<br/>
<br/>

#end -- if not no_summary

# --- currently works for both Functions and Tables. The params field either contains
# --- function parameters or table fields.
# local show_return = not ldoc.no_return_or_parms
# local show_parms = show_return
# for kind, items in module.kinds() do
#   local kitem = module.kinds:get_item(kind)
#   local has_description = kitem and ldoc.descript(kitem) ~= ""
    <h2 class="section-header $(has_description and 'has-description')"><a name="$(no_spaces(kind))"></a>$(kind)</h2>
    $(M(module.kinds:get_section_description(kind),nil))
#   if kitem then
#       if has_description then
          <div class="section-description">
          $(M(ldoc.descript(kitem),kitem))
          </div>
#       end
#       if kitem.usage then
            <h3>Usage:</h3>
            <pre class="example">$(ldoc.prettify(kitem.usage[1]))</pre>
#        end
#   end
    <dl class="function">
#  for item in items() do
    <dt>
    <a name = "$(item.name)"></a>
    <strong>$(display_name(item))</strong>
#   if ldoc.prettify_files and ldoc.is_file_prettified[item.module.file.filename] then
    <a style="float:right;" href="$(ldoc.source_ref(item))">line $(item.lineno)</a>
#  end
    </dt>
    <dd>
    $(M(ldoc.descript(item),item))

#   if ldoc.custom_tags then
#    for custom in iter(ldoc.custom_tags) do
#     local tag = item.tags[custom[1]]
#     if tag and not custom.hidden then
#      local li,il = use_li(tag)
    <h3>$(custom.title or custom[1]):</h3>
    <ul>
#      for value in iter(tag) do
         $(li)$(custom.format and custom.format(value) or M(value))$(il)
#      end -- for
#     end -- if tag
    </ul>
#    end -- iter tags
#   end

#  if show_parms and item.params and #item.params > 0 then
#    local subnames = module.kinds:type_of(item).subnames
#    if subnames then
    <h3>$(subnames):</h3>
#    end
    <ul>
#   for parm in iter(item.params) do
#     local param,sublist = item:subparam(parm)
#     if sublist then
        <li><span class="parameter">$(sublist)</span>$(M(item.params.map[sublist],item))
        <ul>
#     end
#     for p in iter(param) do
#        local name,tp,def = item:display_name_of(p), ldoc.typename(item:type_of_param(p)), item:default_of_param(p)
        <li><span class="parameter">$(name)</span>
#       if tp ~= '' then
            <span class="types">$(tp)</span>
#       end
        $(M(item.params.map[p],item))
#       if def == true then
         (<em>optional</em>)
#      elseif def then
         (<em>default</em> $(def))
#       end
#       if item:readonly(p) then
          <em>readonly</em>
#       end
        </li>
#     end
#     if sublist then
        </li></ul>
#     end
#   end -- for
    </ul>
#   end -- if params

#  if show_return and item.retgroups then local groups = item.retgroups
    <h3>Returns:</h3>
#   for i,group in ldoc.ipairs(groups) do local li,il = use_li(group)
    <ol>
#   for r in group:iter() do local type, ctypes = item:return_type(r); local rt = ldoc.typename(type)
        $(li)
#     if rt ~= '' then
           <span class="types">$(rt)</span>
#     end
        $(M(r.text,item))$(il)
#    if ctypes then
      <ul>
#    for c in ctypes:iter() do
            <li><span class="parameter">$(c.name)</span>
            <span class="types">$(ldoc.typename(c.type))</span>
            $(M(c.comment,item))</li>
#     end
        </ul>
#    end -- if ctypes
#     end -- for r
    </ol>
#   if i < #groups then
     <h3>Or</h3>
#   end
#   end -- for group
#   end -- if returns

#   if show_return and item.raise then
    <h3>Raises:</h3>
    $(M(item.raise,item))
#   end

#   if item.see then
#     local li,il = use_li(item.see)
    <h3>See also:</h3>
    <ul>
#     for see in iter(item.see) do
         $(li)<a href="$(ldoc.href(see))">$(see.label)</a>$(il)
#    end -- for
    </ul>
#   end -- if see

#   if item.usage then
#     local li,il = use_li(item.usage)
    <h3>Usage:</h3>
    <ul>
#     for usage in iter(item.usage) do
        $(li)<pre class="example">$(ldoc.prettify(usage))</pre>$(il)
#     end -- for
    </ul>
#   end -- if usage

</dd>
# end -- for items
</dl>
# end -- for kinds

# else -- if module; project-level contents

# if ldoc.description then
  <h2>$(M(ldoc.description,nil))</h2>
# end
# if ldoc.full_description then
  <p>$(M(ldoc.full_description,nil))</p>
# end

# for kind, mods in ldoc.kinds() do
<h2>$(kind)</h2>
# kind = kind:lower()
<table class="module_list">
# for m in mods() do
	<tr>
		<td class="name"  $(nowrap)><a href="$(no_spaces(kind))/$(m.name).html">$(m.name)</a></td>
		<td class="summary">$(M(ldoc.strip_header(m.summary),m))</td>
	</tr>
#  end -- for modules
</table>
# end -- for kinds
# end -- if module

</div> <!-- id="content" -->
</div> <!-- id="main" -->
<div id="about">
<i>generated by <a href="http://github.com/stevedonovan/LDoc">LDoc $(ldoc.version)</a></i>
<i style="float:right;">Last updated $(ldoc.updatetime) </i>
</div> <!-- id="about" -->
</div> <!-- id="container" -->
</body>
</html>
]==]

