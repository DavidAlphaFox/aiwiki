import { Controller } from "stimulus"
import Quill from 'quill';
import { QuillDeltaToHtmlConverter } from 'quill-delta-to-html';

export default class extends Controller {
  static targets = ['form','content']

  initialize() {
    const toolbarOptions = [
      ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
      ['blockquote', 'code-block'],

      [{ 'header': 1 }, { 'header': 2 }],               // custom button values
      [{ 'header': [3, 4, 5, 6, false] }],
      [{ 'list': 'ordered' }, { 'list': 'bullet' }],
      [{ 'script': 'sub' }, { 'script': 'super' }],      // superscript/subscript
      [{ 'indent': '-1' }, { 'indent': '+1' }],          // outdent/indent
      [{ 'direction': 'rtl' }],                         // text direction
      [{ 'align': [] }],

      ['clean']                                         // remove formatting button
    ];

    this.quill = new Quill('#editor-container', {
      modules: {
        formula: true,
        syntax: true,
        toolbar: toolbarOptions

      },
      theme: 'snow'
    });
  }
  savePage() {
    const delta = this.quill.getContents();
    const converter = new QuillDeltaToHtmlConverter(delta.ops, {});
    const html = converter.convert();
    this.contentTarget.value = html;
    this.formTarget.submit();
  }

}
