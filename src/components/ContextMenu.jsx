import React from "react";
import { MenuItem, connectMenu, ContextMenu } from "react-contextmenu";
import style from "../scss/ContextMenu.scss";

const NoteMenu = props => {
  const { id, trigger } = props;
  const handleItemClick = trigger ? trigger.onItemClick : null;

  return (
    <ContextMenu id={id} className={style.contextmenu}>
      {trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Open" }}
        >
          Otwórz
        </MenuItem>
      )}
      {trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Properties" }}
        >
          Właściwości
        </MenuItem>
      )}
      {trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Delete" }}
        >
          Usuń
        </MenuItem>
      )}
    </ContextMenu>
  );
};

const NoteGroupMenu = props => {
  const { id, trigger } = props;
  const handleItemClick = trigger ? trigger.onItemClick : null;

  return (
    <ContextMenu id={id} className={style.contextmenu}>
      {trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Properties" }}
        >
          Właściwości
        </MenuItem>
      )}
      {/*trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Change icon" }}
        >
          Zmień ikonę
        </MenuItem>
      )*/}
      {trigger && (
        <MenuItem
          className={style.contextmenu_item}
          onClick={handleItemClick}
          data={{ action: "Delete" }}
        >
          Usuń
        </MenuItem>
      )}
    </ContextMenu>
  );
};

export const ConnectedMenu = connectMenu("DYNAMIC")(NoteMenu);
export const ConnectedGroupMenu = connectMenu("NOTEGROUP")(NoteGroupMenu);
