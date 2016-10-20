$(function() {
    console.log("JQUERY LOADED!");
    
    var previewImage = $('#preview-image');
    var photoUrlInput = $('#photo_url');
    
    //this if or the 'posts/new' input field
    photoUrlInput.on('blur', function() {
        console.log(photoUrlInput.val());
        previewImage.attr('src', photoUrlInput.val());
    });
});