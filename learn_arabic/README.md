# learn_arabic

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
```js
function vdlist(){
    var doc=document.querySelectorAll('#secondary-inner #playlist a#wc-endpoint'),
        ids=[];

    doc.forEach(a=>{
    
    var str=a.href.replace('https://www.youtube.com/watch?v=','');
    ids.push({id:str.substr(0, str.indexOf('&')), title:a.querySelector('span#video-title').title});

    });

    console.log(JSON.stringify(ids))
}

```
