[].forEach.call(document.getElementsByClassName('tags-input'), function (el) {
    let hiddenInput,
        mainInput = document.createElement('textarea'),
        stored,
        tagNumber = 0,
        tags = [];
    if(window.location.href.indexOf("gigs") > -1) {
       hiddenInput = document.getElementById('gig_tag_list');
    }
    else{
      hiddenInput = document.getElementById('request_tag_list');
    }

    mainInput.setAttribute('type', 'text');
    mainInput.setAttribute('rows', 1);
    mainInput.classList.add('main-input', 'form-control');
    mainInput.addEventListener('input', function () {
        let enteredTags = mainInput.value.split('\n');
        let enteredTags2 = mainInput.value.split(' ');

        if (enteredTags.length > 1 || enteredTags2.length > 1) {
          let filteredTag = filterTag(enteredTags[0]);
          if (tagNumber<5){
            if(filteredTag.length > 0 && filteredTag.length < 16){
              $(".tag-error" ).html("");
              addTag(filteredTag);
            }
            else{
              $(".tag-error" ).html("Cada tag debe contener de 1 a 15 caracteres");
            }
          }
          else{
            $(".tag-error" ).html("Sólo se admiten un máximo de 5 tags");
          }
          mainInput.value = '';

        }
    });

    mainInput.addEventListener('keydown', function (e) {
        let keyCode = e.which || e.keyCode;
        if (keyCode === 8 && mainInput.value.length === 0 && tags.length > 0) {
            removeTag(tags.length - 1);
        }
    });

    el.appendChild(mainInput);

    if (hiddenInput.value != ""){
      stored = hiddenInput.value.split(" ");
      stored.forEach(function(tag) {
        addTag(tag);
      });

    }


    function addTag (text) {
        let tag = {
            text: text,
            element: document.createElement('span'),
        };

        tag.element.classList.add('tag');
        tag.element.textContent = tag.text;

        let closeBtn = document.createElement('span');
        closeBtn.classList.add('close');
        closeBtn.addEventListener('click', function () {
            removeTag(tags.indexOf(tag));
        });
        tag.element.appendChild(closeBtn);

        tags.push(tag);

        el.insertBefore(tag.element, mainInput);
        tagNumber+=1;

        refreshTags();
    }

    function removeTag (index) {
        let tag = tags[index];
        tags.splice(index, 1);
        el.removeChild(tag.element);
        tagNumber-=1;
        refreshTags();
    }

    function refreshTags () {
        let tagsList = [];
        tags.forEach(function (t) {
            tagsList.push(t.text);
        });
        hiddenInput.value = tagsList.join(',');
    }

    function filterTag (tag) {
        return tag.replace(/[^\w -]/g, '').trim();
    }
});
