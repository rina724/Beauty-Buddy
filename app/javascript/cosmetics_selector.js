document.addEventListener('turbo:load', () => {
  console.log('Cosmetics selector script loaded');
  
  initializeExistingCosmeticButtons();
});

function initializeExistingCosmeticButtons() {
  document.querySelectorAll('#selected-cosmetics > div').forEach(button => {
    button.addEventListener('click', (e) => {
      e.preventDefault();
      const cosmeticId = button.id.split('-')[1];
      removeCosmeticField(cosmeticId);
    });
  });
}

window.addSelectedCosmetics = function() {
  const select = document.getElementById('cosmetic-select');
  const selectedOptions = Array.from(select.selectedOptions);
  const selectedCosmeticsDiv = document.getElementById('selected-cosmetics');
  
  selectedOptions.forEach((option) => {
    const cosmeticId = option.value;
    const cosmeticName = option.text;
    
    let existingField = document.getElementById(`cosmetic-${cosmeticId}`);
    if (existingField) {
      const destroyField = existingField.querySelector('input[name$="[_destroy]"]');
      if (destroyField) {
        destroyField.value = "false";
      }
      existingField.style.display = '';
    } else {
      const newDiv = document.createElement('div');
      newDiv.id = `cosmetic-${cosmeticId}`;
      newDiv.className = 'btn btn-sm btn-outline max-w-full h-auto p-3 flex items-center';
      newDiv.innerHTML = `
        ${cosmeticName}
        <input type="hidden" name="daily_report[daily_report_cosmetics_attributes][][mycosmetic_id]" value="${cosmeticId}">
      `;
      newDiv.addEventListener('click', (e) => {
        e.preventDefault();
        removeCosmeticField(cosmeticId);
      });
      selectedCosmeticsDiv.appendChild(newDiv);
    }
  });
  
  select.selectedIndex = -1;
  window.my_modal_3.close();
};

window.removeCosmeticField = function(cosmeticId) {
  const field = document.getElementById(`cosmetic-${cosmeticId}`);
  if (field) {
    const existingIdInput = field.querySelector('input[name$="[id]"]');
    if (existingIdInput) {
      let destroyInput = field.querySelector('input[name$="[_destroy]"]');
      if (!destroyInput) {
        destroyInput = document.createElement('input');
        destroyInput.type = 'hidden';
        destroyInput.name = existingIdInput.name.replace('[id]', '[_destroy]');
        field.appendChild(destroyInput);
      }
      destroyInput.value = "1";
      field.style.display = 'none';
    } else {
      field.remove();
    }
  }
};