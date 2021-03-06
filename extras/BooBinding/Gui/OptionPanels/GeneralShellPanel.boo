#region license
// Copyright (c) 2005, Peter Johanson (latexer@gentoo.org)
// All rights reserved.
//
// BooBinding is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// 
// BooBinding is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with BooBinding; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#endregion

namespace BooBinding.Gui.OptionPanels

import System
import Gtk

import MonoDevelop.Core

import BooBinding.Properties

public class GeneralShellPanel(MonoDevelop.Ide.Gui.Dialogs.OptionsPanel):
	private generalOptionsLabel = Gtk.Label ()
	private autoIndentCheckButton = Gtk.CheckButton ()
	private resetClearsScrollbackCheckButton = Gtk.CheckButton ()
	private resetClearsHistoryCheckButton = Gtk.CheckButton ()
	private loadAssemblyCheckButton = Gtk.CheckButton ()

	private fontOptionsLabel = Gtk.Label ()
	private fontButton = FontButton ()
	private defaultMonoRadio as RadioButton
	private customFontRadio as RadioButton

	protected virtual ShellProperties as ShellProperties:
		get:
			pass

	private def InitializeComponent() as void:
		generalOptionsLabel.Markup = String.Format ("<b>{0}</b>", GettextCatalog.GetString ("General Options"))

		autoIndentCheckButton.Label = GettextCatalog.GetString ("Automatically indent new lines in code blocks")
		resetClearsScrollbackCheckButton.Label = GettextCatalog.GetString ("Shell reset clears scollback")
		resetClearsHistoryCheckButton.Label = GettextCatalog.GetString ("Shell reset clears command history")
		loadAssemblyCheckButton.Label = GettextCatalog.GetString ("Load project assemblies after building them (Causes shell reset)")
		fontOptionsLabel.Markup = String.Format ("<b>{0}</b>", GettextCatalog.GetString ("Font"))
		defaultMonoRadio = RadioButton (GettextCatalog.GetString ("Use default monospace font"))
		customFontRadio = RadioButton (defaultMonoRadio, GettextCatalog.GetString ("Use custom font:"))

		defaultMonoRadio.Toggled += ItemToggled
		customFontRadio.Toggled += ItemToggled


	public override def CreatePanelWidget( ) as Widget:
		InitializeComponent ()
		vbox = VBox ()
		hboxTmp = HBox()
		hboxTmp.PackStart (generalOptionsLabel, false, false, 0)
		vbox.PackStart (hboxTmp, false, false, 12)
		hboxTmp = HBox()
		hboxTmp.PackStart (autoIndentCheckButton, false, false, 6)
		vbox.PackStart (hboxTmp, false, false, 0)
		hboxTmp = HBox()
		hboxTmp.PackStart (resetClearsScrollbackCheckButton, false, false, 6)
		vbox.PackStart (hboxTmp, false, false, 0)
		hboxTmp = HBox()
		hboxTmp.PackStart (resetClearsHistoryCheckButton, false, false, 6)
		vbox.PackStart (hboxTmp, false, false, 0)
		hboxTmp = HBox()
		hboxTmp.PackStart (loadAssemblyCheckButton, false, false, 6)
		vbox.PackStart (hboxTmp, false, false, 0)
		hboxTmp = HBox()
		hboxTmp.PackStart (fontOptionsLabel, false, false, 0)
		vbox.PackStart (hboxTmp, false, false, 12)
		hboxTmp = HBox()
		hboxTmp.PackStart(defaultMonoRadio, false, false, 6)
		vbox.PackStart (hboxTmp, false, false, 0)
		hboxTmp = HBox()
		hboxTmp.PackStart (customFontRadio, false, false, 6)
		hboxTmp.PackStart (fontButton, false, false, 0)
		vbox.PackStart (hboxTmp, false, false, 0)

		s = ShellProperties.FontName

		if s == "__default_monospace":
			defaultMonoRadio.Active = true
		else:
			fontButton.FontName = s
			customFontRadio.Active = true

		fontButton.Sensitive = customFontRadio.Active
		autoIndentCheckButton.Active = ShellProperties.AutoIndentBlocks
		resetClearsScrollbackCheckButton.Active = ShellProperties.ResetClearsScrollback
		resetClearsHistoryCheckButton.Active = ShellProperties.ResetClearsHistory
		loadAssemblyCheckButton.Active =  ShellProperties.LoadAssemblyAfterBuild
		vbox.ShowAll ()
		return vbox


	public override def ApplyChanges () as void:
		if customFontRadio.Active:
			ShellProperties.FontName =  fontButton.FontName
		elif defaultMonoRadio.Active:
			ShellProperties.FontName = "__default_monospace"

		if ShellProperties.AutoIndentBlocks != autoIndentCheckButton.Active:
			ShellProperties.AutoIndentBlocks = autoIndentCheckButton.Active

		if ShellProperties.ResetClearsScrollback != resetClearsScrollbackCheckButton.Active:
			ShellProperties.ResetClearsScrollback = resetClearsScrollbackCheckButton.Active
		if ShellProperties.ResetClearsHistory != resetClearsHistoryCheckButton.Active:
			ShellProperties.ResetClearsHistory = resetClearsHistoryCheckButton.Active
		if ShellProperties.LoadAssemblyAfterBuild != loadAssemblyCheckButton.Active:
			ShellProperties.LoadAssemblyAfterBuild = loadAssemblyCheckButton.Active
	
	private def ItemToggled (o, args as EventArgs):
		fontButton.Sensitive = customFontRadio.Active
