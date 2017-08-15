$(function() {

  // Markdown plain out to bootstrap style
  $('#post-content table').addClass('table table-bordered');
  $('#post-content thead').addClass('thead-inverse');
  $('#post-content p img').addClass('img-fluid')
    .parent().addClass('text-center');


  MathJax.Hub.Config({
    CommonHTML: {
      scale: 112
    }
  });
});
