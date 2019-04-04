$(document).on('turbolinks:load', function() {
  startTags();
});

function startTags() {
  if ($(".tags-input").length == 1 && $(".tags-input .initialized").length == 0) {
    let hiddenInput,
      el = document.getElementsByClassName('tags-input'),
      // mainInput = document.createElement('textarea'),
      mainInput = $('.main-input')[0],
      stored,
      tagNumber = 0,
      tags = [];

      hiddenInput = document.getElementsByClassName('hidden_tag_list')[0];

      mainInput.classList.add('initialized');


    // mainInput.setAttribute('type', 'text');
    // mainInput.setAttribute('rows', 1);

    // if (window.location.href.indexOf("configuration") > -1) {
    // }
    // else{
    //   mainInput.classList.add('main-input', 'tags-main-input');
    // }
    mainInput.addEventListener('input', function() {
      let enteredTags = mainInput.value.split('\n');
      let enteredTags2 = mainInput.value.replace(/^ +/gm, '');
      enteredTags2 = enteredTags2.split(' ');

      if (enteredTags.length > 1 || enteredTags2.length > 1) {
        if (tagNumber < 5) {
          if (enteredTags[0].length > 0 && enteredTags[0].length < 16 || enteredTags2[0].length > 0 && enteredTags2[0].length < 16) {
            $(".tag-error").html("");
            addTag(enteredTags[0], "yes");
          } else {
            $(".tag-error").html("Cada tag debe contener de 1 a 15 caracteres");
          }
        } else {
          $(".tag-error").html("Sólo se admiten un máximo de 5 tags");
        }
        mainInput.value = '';

      }
    });

    mainInput.addEventListener('keydown', function(e) {
      let keyCode = e.which || e.keyCode;
      if (keyCode === 8 && mainInput.value.length === 0 && tags.length > 0) {
        removeTag(tags.length - 1);
      }
    });
    // el[0].appendChild(mainInput);

    if (hiddenInput.value != "") {
      stored = hiddenInput.value.split(" ");
      stored.forEach(function(tag) {
        addTag(tag);
      });

    }


    function addTag(text, enter="no") {
      let tag = {
        text: text,
        element: document.createElement('span'),
      };

      tag.element.classList.add('tag');
      tag.element.textContent = tag.text;

      let closeBtn = document.createElement('span');
      closeBtn.classList.add('close');
      closeBtn.addEventListener('click', function() {
        removeTag(tags.indexOf(tag));
      });
      tag.element.appendChild(closeBtn);

      tags.push(tag);

      el[0].insertBefore(tag.element, mainInput);
      tagNumber += 1;
      refreshTags();
      if( enter == "yes" && window.location.href.indexOf("configuration") > -1 ) {
        $('form.config-tag-form input[type=submit]').click();
      }
    }

    function removeTag(index) {
      let tag = tags[index];
      tags.splice(index, 1);
      el[0].removeChild(tag.element);
      tagNumber -= 1;
      refreshTags();
      if (window.location.href.indexOf("configuration") > -1) {
        $('form.config-tag-form input[type=submit]').click();
      }
    }

    function refreshTags() {
      let tagsList = [];
      tags.forEach(function(t) {
        tagsList.push(t.text);
      });
      hiddenInput.value = tagsList.join(',');
    }
  }
}