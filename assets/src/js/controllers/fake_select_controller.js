import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['container','select'];
  initialize() {
    this.fakeSelect = null;
    this.fakeOptions = null;
  }
  connect() {
    const selectedIndex = this.selectTarget.selectedIndex;
    const selectOptions = this.selectTarget.options;
    this.fakeSelect  = document.createElement('div');
    this.fakeSelect.setAttribute('class', 'select-field');
    this.fakeSelect.innerHTML = selectOptions[selectedIndex].innerHTML;
    this.containerTarget.appendChild(this.fakeSelect);
    this.fakeOptions = document.createElement('div');
    this.fakeOptions.setAttribute('class', 'select-items select-hide');
    const self = this;
    for (let index = 0; index < selectOptions.length; index++) {
      const option = document.createElement('div');
      option.innerHTML = selectOptions[index].innerHTML;
      const optionIndex = index;
      option.addEventListener('click', function(e) {
        self.selectTarget.selectedIndex = optionIndex;
        self.fakeSelect.innerHTML = option.innerHTML;
        const oldSelected = option.parentNode.getElementsByClassName('select-selected');
        for (let oldIndex = 0; oldIndex < oldSelected.length; oldIndex++) {
          oldSelected[oldIndex].removeAttribute('class');
        }
        option.setAttribute('class', 'select-selected');
        self.closeSelect();
      });
      if(index === selectedIndex) {
        option.setAttribute('class','select-selected');
      }
      this.fakeOptions.appendChild(option);
    }
    
    this.containerTarget.appendChild(this.fakeOptions);
    this.fakeSelect.addEventListener('click', function(e) {
      e.stopPropagation();
      self.fakeOptions.classList.toggle('select-hide');
    });
  }
  disconnect(){
    this.containerTarget.removeChild(this.fakeSelect);
    this.containerTarget.removeChild(this.fakeOptions);
  }
  closeSelect(){
    this.fakeOptions.classList.add('select-hide');
  }
}
