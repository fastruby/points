document.addEventListener('DOMContentLoaded', function() {
  // smooth scroll to anchors
  document.querySelectorAll("#main-nav a").forEach( function(a){
    var el = document.getElementById(a.hash.replace('#',''));
    var elPosition = el.getBoundingClientRect();
    a.addEventListener('click', function(evn){
      evn.preventDefault();

      document.querySelectorAll('#main-nav a').forEach( function(a){ a.classList.remove('nav-active') });
      document.querySelector('[href="' + a.hash + '"]').classList.add('nav-active');

      window.location.hash = a.hash;
      window.scroll({
        top: elPosition.y,
        left: 100,
        behavior: 'smooth'
      });
      
    })
  });

  // use intersection observer to detect section
  // detect element on the top portion
  var options = {
    rootMargin: '-45% 0px -35% 0px'
  }

  // set current element nav class
  function callback(entries){
    entries.forEach(function(entry){
      if (entry.isIntersecting) {
        document.querySelectorAll('#main-nav a').forEach( function(a){ a.classList.remove('nav-active') });
        document.querySelector('[href="#' + entry.target.id + '"]').classList.add('nav-active');
      }
    })
  }

  // create observer
  var observer = new IntersectionObserver(callback, options);

  // observe all elements
  document.querySelectorAll('#sections > div').forEach(function(section){
    observer.observe(section);
  })

  // prevent links default behavior
  document.querySelectorAll('a').forEach( function(a){
    a.addEventListener('click', function(event) { event.preventDefault() });
  });

  document.getElementById("nav-button").addEventListener('click', function() {
    document.getElementById('main-nav').classList.toggle('open');
    document.getElementById('nav-button').classList.toggle('open');
    document.body.classList.toggle('modal-active');
  });

  document.querySelectorAll('#main-nav a').forEach( function(a){
    a.addEventListener('click', function() {
      document.getElementById('main-nav').classList.remove('open');
      document.getElementById('nav-button').classList.remove('open');
      document.body.classList.remove('modal-active');
    })
  })
});