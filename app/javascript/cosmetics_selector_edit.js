document.addEventListener('turbo:load', () => {
  if (document.querySelector('.edit-daily-report-form')) {
    initializeEditCosmeticsSelector();
  }
});

function initializeEditCosmeticsSelector() {
  const selectedCosmetics = document.getElementById('selected-cosmetics');
  if (selectedCosmetics) {
    selectedCosmetics.addEventListener('click', handleCosmeticRemoval);
  }
}

function handleCosmeticRemoval(event) {
  if (event.target.classList.contains('remove-cosmetic')) {
    event.preventDefault();
    const cosmeticDiv = event.target.closest('div');
    const destroyFlag = cosmeticDiv.querySelector('.destroy-flag');
    if (destroyFlag) {
      destroyFlag.value = 'true';
    }
    cosmeticDiv.style.display = 'none';
  }
}

window.addSelectedCosmeticsEdit = function() {
  const select = document.getElementById('cosmetic-select');
  const selectedCosmetics = document.getElementById('selected-cosmetics');
  let newIndex = selectedCosmetics.children.length;
  
  Array.from(select.selectedOptions).forEach(option => {
    if (!document.getElementById(`cosmetic-${option.value}`)) {
      const div = document.createElement('div');
      div.id = `cosmetic-${option.value}`;
      div.className = 'btn btn-sm btn-outline max-w-full h-auto p-3 flex items-center';
      div.innerHTML = `
        ${option.text}
        <input type="hidden" name="daily_report[daily_report_cosmetics_attributes][${newIndex}][mycosmetic_id]" value="${option.value}">
        <input type="hidden" name="daily_report[daily_report_cosmetics_attributes][${newIndex}][_destroy]" value="false" class="destroy-flag">
      `;
      selectedCosmetics.appendChild(div);
      newIndex++;
    }
  });
  
  window.my_modal_3.close();
};