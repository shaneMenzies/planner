public class Plugins.CanvasIntegration : Peas.ExtensionBase, Peas.Activatable {
    public Object object { owned get; construct; }
    
    public Gtk.ListBox listbox;
    public int index {get; set; }

    private Gtk.Revealer main_revealer;
    private Gtk.Grid main_grid;
    
    public void activate() {

        Planner.database.open_database();

        int64 project_id = 3034265335;
        string section_id_output = "";

        Gee.ArrayList<Objects.Section?> section_list = Planner.database.get_all_sections();

        foreach(Objects.Section section in section_list) {

            section_id_output += section.name;
            section_id_output += section.id.to_string();
            section_id_output += "\n";

            var debugDialog = new Gtk.MessageDialog(Planner.main_window.MainWindow, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.CLOSE ,"%s", section_id_output );

        }
        
        int priority = 1;
        int64 section_id = 1;
        int is_todoist = 0;
        string due_date = "tomorrow";

        var item = new Objects.Item ();
                item.priority = priority;         
                item.project_id = project_id;
                item.section_id = section_id;
                item.is_todoist = is_todoist;
                item.due_date = due_date;
                item.content = "test test test";
                item.note = "Test Test Test";
                int64 temp_id_mapping = Planner.utils.generate_id ();
                
                if (is_todoist == 1) {
                    var cancellable = new Cancellable ();
                    Planner.todoist.add_item.begin (item, cancellable, index, temp_id_mapping);
                } else {
                    item.id = Planner.utils.generate_id ();
                    if (Planner.database.insert_item (item, index)) {
                        var i = index;
                        if (i != -1) {
                            i++;
                        }

                        var new_item = new Widgets.NewItem (
                            project_id,
                            section_id,
                            is_todoist,
                            due_date,
                            i,
                            listbox,
                            priority
                        );

                        if (index == -1) {
                            listbox.add (new_item);
                        } else {
                            listbox.insert (new_item, i);
                        }

                        listbox.show_all ();
                    }
                }
    }

    public void deactivate() {
        hide_destroy();
    }

    public void update_state() {}

    public void hide_destroy() {
            main_revealer.reveal_child = false;
            Timeout.add (500, () => {
                main_grid.destroy ();
                return false;
            });
    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (
        typeof (Peas.Activatable),
        typeof (Plugins.CanvasIntegration)
    );
}
